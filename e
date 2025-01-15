const { MongoClient } = require('mongodb');
const { purple } = require("../../loaders/reader");
const { EmbedBuilder } = require("discord.js");
const uri = process.env['uri'];
const logger = require('../../utils/logger'); 

// Verbindung zur MongoDB
const client = new MongoClient(uri);

// Mapping von Emojis zu Rollen
const roleMapping = {
    '🚑': 'Rettungsdienst',
    '🚒': 'Feuerwehr',
    '🚓': 'Polizei',
};

// MongoDB-Funktionen
async function startShift(userId, username, role, startTime) {
    await client.connect();
    const db = client.db('RPServer');
    const shifts = db.collection('shifts');
    const query = { userId, role, endTime: null };
    const updateDoc = {
        $set: { userId, username, role, startTime, endTime: null },
    };
    const options = { upsert: true };
    await shifts.updateOne(query, updateDoc, options);
    await client.close();
}

async function endShift(userId, role, endTime) {
    await client.connect();
    const db = client.db('RPServer');
    const shifts = db.collection('shifts');
    const query = { userId, role, endTime: null };
    const shift = await shifts.findOne(query);

    if (shift) {
        const duration = Math.round((endTime - new Date(shift.startTime)) / 60000); // Minuten
        const updateDoc = { $set: { endTime, duration } };
        await shifts.updateOne(query, updateDoc);
        await client.close();
        return duration;
    }

    await client.close();
    return null;
}

// Command-Export
module.exports = {
    config: {
        name: "schicht",
        aliases: [],
        usage: "Startet ein Schicht-System mit Reaction Roles.",
        description: "",
        permissions: [],
    },

    run: async (bot, message, args) => {
        // Embed erstellen
        const embed = new EmbedBuilder()
            .setColor(purple)
            .setTitle('Schichtsystem')
            .setDescription(
                'Reagiere mit einem Emoji, um eine Schicht zu starten oder zu beenden:\n' +
                '🚑 - Rettungsdienst\n' +
                '🚒 - Feuerwehr\n' +
                '🚓 - Polizei'
            )
            .setFooter({ text: 'Reagiere erneut, um die Schicht zu beenden.' });

        // Nachricht senden
        const sentMessage = await message.channel.send({ embeds: [embed] });

        // Emojis hinzufügen
        for (const emoji of Object.keys(roleMapping)) {
            await sentMessage.react(emoji);
        }

        // Reaction-Handler
        const filter = (reaction, user) => {
            return Object.keys(roleMapping).includes(reaction.emoji.name) && !user.bot;
        };

        const collector = sentMessage.createReactionCollector({ filter, dispose: true });

        collector.on('collect', async (reaction, user) => {
            const role = roleMapping[reaction.emoji.name];
            const startTime = new Date();
            logger.log("check 1")

            await startShift(user.id, user.username, role, startTime);
            const dmChannel = await user.createDM();
            dmChannel.send(`Du hast deine Schicht als **${role}** gestartet.`);
        });

        collector.on('remove', async (reaction, user) => {
            const role = roleMapping[reaction.emoji.name];
            const endTime = new Date();
            logger.log("check2")

            const duration = await endShift(user.id, role, endTime);
            const dmChannel = await user.createDM();

            if (duration !== null) {
                dmChannel.send(
                    `Du hast deine Schicht als **${role}** beendet. Dauer: ${duration} Minuten.`
                );
            } else {
                dmChannel.send('Du hattest keine aktive Schicht mit dieser Rolle.');
            }
        });
    },
};
