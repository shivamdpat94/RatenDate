const functions = require("firebase-functions");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Firestore-triggered function to match users in CallWaiting collection
exports.matchUsersInCallWaiting = functions.firestore
    .document("CallWaiting/{userEmail}")
    .onCreate(async (snapshot, context) => {
      // Get reference to Firestore
      const db = admin.firestore();

      // Extract the email of the user who was just added to CallWaiting
      const userEmail = context.params.userEmail;

      // Randomly match with another user in CallWaiting
      try {
        const CallWaitingCollection = db.collection("CallWaiting");
        const querySnapshot = await CallWaitingCollection.get();

        let matchedUserEmail = null;

        // Loop through the documents in CallWaiting
        querySnapshot.forEach((doc) => {
          if (doc.id !== userEmail && !matchedUserEmail) {
            matchedUserEmail = doc.id;
          }
        });

        // If a match is found, update both documents
        if (matchedUserEmail) {
          // make a batch to perform multiple write operations as a single unit
          const batch = db.batch();

          // Set the matched user's email in each user's document
          const currentUserDocRef = CallWaitingCollection.doc(userEmail);
          const matchedUserDocRef = CallWaitingCollection.doc(matchedUserEmail);

          batch.update(currentUserDocRef, {
            matchedEmail: matchedUserEmail,
          });
          batch.update(matchedUserDocRef, {
            matchedEmail: userEmail,
          });

          // Commit the batch operation
          await batch.commit();
          logger.info(`Matched users: ${userEmail} and ${matchedUserEmail}`);
        } else {
          logger.info(`No match found for user: ${userEmail}`);
        }
      } catch (error) {
        logger.error(`Error matching users in CallWaiting: ${error.message}`);
      }
    });
