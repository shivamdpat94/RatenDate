/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendPushNotification = functions.firestore
    .document('Chats/{matchId}/Messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        const messageData = snapshot.data();
        console.log("message data: ", messageData);

        // Reference to the chat document to get participants
        const chatRef = admin.firestore().collection('Chats').doc(context.params.matchId);
        const chatSnapshot = await chatRef.get();
        const chatData = chatSnapshot.data();
        console.log("Chat data: ", chatData);

        // Determine the receiver's email by filtering out the sender's email from participants
        const receiverEmail = chatData.participants.find(email => email !== messageData.email);
        console.log("Reciever Email: ", receiverEmail);

        // Retrieve sender's profile to get their first name
        const senderProfileRef = admin.firestore().collection('profiles').doc(messageData.email);
        const senderProfileSnapshot = await senderProfileRef.get();
        const senderProfile = senderProfileSnapshot.data();

        // Retrieve receiver's profile to get their FCM token
        const receiverProfileRef = admin.firestore().collection('profiles').doc(receiverEmail);
        const receiverProfileSnapshot = await receiverProfileRef.get();
        const receiverProfile = receiverProfileSnapshot.data();

        // Check if receiver's FCM token exists
        if (!receiverProfile || !receiverProfile.fcmToken) {
            console.log(`No FCM token found for receiver: ${receiverEmail}`);
            return null;
        }

        // Construct the notification payload
        const payload = {
            notification: {
                title: `New message from ${senderProfile.firstName}`,
                body: messageData.text
            },
            data: {
                matchId: context.params.matchId // include the matchId or other identifier in the data payload
            },
            token: receiverProfile.fcmToken
        };

        try {
            const response = await admin.messaging().send(payload);
            console.log('Successfully sent message:', response);
        } catch (error) {
            console.log('Error sending message:', error);
        }
    });