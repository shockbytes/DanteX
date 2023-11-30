const database = require('./database')
const functions = require('firebase-functions');
const firebase = require('firebase-admin');
const express = require('express');
const cors = require('cors')({origin: true});

const firebaseApp = firebase.initializeApp(functions.firebaseConfig());

const app = express();
app.use(decodeIdToken);
app.use(cors);

app.get("/health", handleHealthCheck);
app.get("/suggestions", handleSuggestionsRequest);
app.post("/suggestions/:suggestionId/report", handleReportSuggestion);
app.post("/suggestions/:suggestionId/like", handleLikeSuggestion);
app.post("/suggestions", handleNewSuggestion)

async function decodeIdToken(request, response, next) {

    let authToken = request.headers.authorization

    if (authToken !== undefined && authToken.startsWith('Bearer')) {

        let idToken = authToken.split('Bearer ')[1];

        try {
            request['decoded_token'] = await firebaseApp.auth().verifyIdToken(idToken);
        } catch (error) {
            console.error(error)
        }
    }

    next()
}

function handleHealthCheck(request, response) {
    return response.status(200).send('{ "health": "ok" }')
}

function handleSuggestionsRequest(request, response) {

    let decodedIdToken = request['decoded_token'];

    if (!decodedIdToken) {
        response.status(403).send("User must be logged in!")
        return;
    }

    database.getSuggestions(firebaseApp, decodedIdToken.uid)
        .then(suggestions => {
            let suggestionResponse = {"suggestions": suggestions};
            return response.status(200).json(suggestionResponse)
        })
        .catch(reason => response.status(404).json(reason))
}

function handleLikeSuggestion(request, response) {

    let decodedIdToken = request['decoded_token'];

    if (!decodedIdToken) {
        response.status(403).send("User must be logged in!")
        return;
    }

    let suggestionId = request.params.suggestionId;

    let likeRequestContent = request.body;
    let isLikedByMe = likeRequestContent.isLikedByMe;
    let likeOperation = isLikedByMe ? -1 : 1;

    firebaseApp.database()
        .ref("suggestions")
        .child(suggestionId)
        .once('value')
        .then(suggestion => {

            let likes = suggestion.val().likes;
            if (likes === undefined || likes === null) {
                likes = 0;
            }

            // eslint-disable-next-line promise/no-nesting
            return suggestion.ref.update({
                'likes': likes + likeOperation
            }).then(() => response.status(200).send(`Suggestion with ID: ${suggestionId} liked with operation ${likeOperation}`))
        })
        .catch(reason => response.status(404).json(reason))
}

function handleReportSuggestion(request, response) {

    let decodedIdToken = request['decoded_token'];

    if (!decodedIdToken) {
        response.status(403).send("User must be logged in!")
        return;
    }

    let suggestionId = request.params.suggestionId

    firebaseApp.database()
        .ref("suggestions")
        .child(suggestionId)
        .once('value')
        .then(suggestion => {
            // eslint-disable-next-line promise/no-nesting
            return suggestion.ref.update({
                'reports': suggestion.val().reports + 1
            }).then(() => response.status(200).send(`Reported suggestion with ID: ${suggestionId}`))
        })
        .catch(reason => response.status(404).json(reason))
}

function handleNewSuggestion(request, response) {

    let decodedIdToken = request['decoded_token'];

    if (!decodedIdToken) {
        response.status(403).send("User must be logged in!")
        return;
    }

    let suggestionRequest = request.body

    let suggester = {
        'name': decodedIdToken.name,
        'uid': decodedIdToken.uid,
        'picture': decodedIdToken.picture
    };

    // eslint-disable-next-line consistent-return
    return database.saveSuggestion(firebaseApp, suggestionRequest, suggester)
        .then(() => response.status(200).send())
        .catch(reason => response.status(500).send(reason))
}


// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions
exports.app = functions.https.onRequest(app);
