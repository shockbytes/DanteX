const SUGGESTIONS_PER_REQUEST = 9;
const MAXIMUM_REPORTS = 3;

class Suggestion {

    constructor(suggestionId, suggestion, suggester, recommendation, createdAt, likes) {
        this.suggestionId = suggestionId;
        this.suggestion = suggestion;
        this.suggester = suggester;
        this.recommendation = recommendation;
        this.reports = 0;
        this.createdAt = createdAt;
        this.likes = likes;
    }
}

// eslint-disable-next-line no-extend-native
Object.defineProperty(Array.prototype, 'shuffle', {
    value: function () {
        for (let i = this.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this[i], this[j]] = [this[j], this[i]];
        }
        return this;
    }
});

module.exports = {

    getSuggestions: function (firebaseApp, requesterUserId) {
        let ref = firebaseApp.database().ref("suggestions");

        const data = [];

        return ref.once('value').then(suggestions => {
            suggestions.forEach(snapshot => {
                let value = snapshot.val()

                if (value.likes === undefined || value.likes === null) {
                    value.likes = 0;
                }

                data.push(value);
            });

            // Filter suggestions that are from the same user that requests the suggestions now
            // and which are not reported yet
            return data
                // TODO Also consider the date when it was suggested by others
                .filter(s => s.suggester.uid !== requesterUserId && s.reports < MAXIMUM_REPORTS)
                .shuffle()
                .slice(0, SUGGESTIONS_PER_REQUEST)

        });
    },
    saveSuggestion: function (firebaseApp, suggestionRequest, suggester) {

        let ref = firebaseApp.database().ref("suggestions");
        let key = ref.push().key;

        let data = new Suggestion(
            key,
            suggestionRequest.suggestion,
            suggester,
            suggestionRequest.recommendation,
            Date.now(),
            0
        )

        return ref.child(key).set(data);
    }
}
