/**
 * App ID for the skill
 */
var request = require('request')
var APP_ID = "amzn1.echo-sdk-ams.app.9db0bf66-bb7d-48f3-8a98-17e67d7fc0be"; //replace with "amzn1.echo-sdk-ams.app.[your-unique-value-here]";

/**
 * The AlexaSkill prototype and helper functions
 */
var AlexaSkill = require('./AlexaSkill');

/**
 * Hello is a child of AlexaSkill.
 * To read more about inheritance in JavaScript, see the link below.
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Introduction_to_Object-Oriented_JavaScript#Inheritance
 */
var Hello = function () {
    AlexaSkill.call(this, APP_ID);
};

// Extend AlexaSkill
Hello.prototype = Object.create(AlexaSkill.prototype);
Hello.prototype.constructor = Hello;

Hello.prototype.eventHandlers.onSessionStarted = function (sessionStartedRequest, session) {
    console.log("Hello onSessionStarted requestId: " + sessionStartedRequest.requestId
        + ", sessionId: " + session.sessionId);
    // any initialization logic goes here
};

Hello.prototype.eventHandlers.onLaunch = function (launchRequest, session, response) {
    console.log("Hello onLaunch requestId: " + launchRequest.requestId + ", sessionId: " + session.sessionId);
    var speechOutput = "Welcome to the Alexa Skills Kit, you can say hello";
    var repromptText = "You can say hello";
    response.ask(speechOutput, repromptText);
};

Hello.prototype.eventHandlers.onSessionEnded = function (sessionEndedRequest, session) {
    console.log("Hello onSessionEnded requestId: " + sessionEndedRequest.requestId
        + ", sessionId: " + session.sessionId);
    // any cleanup logic goes here
};

Hello.prototype.intentHandlers = {
    // register custom intent handlers
    "FlyDrone": function (intent, session, response) {
        response.intent.latitude, response.intent.longitude
        var options = {
            url: 'https://api.github.com/repos/request/request',
            headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' },
            body: JSON.stringify({ "long": response.intent.longitude, "lat": response.intent.latitude })
        };
        request.post(options, function(err, res, body){
            if(!err)
                response.tellWithCard("Let's fly the drone", "Flying drone", "Let's get lot of water data");
            else
                response.tellWithCard("Oh no. We could not reach the server")
        })
    },
    "AMAZON.HelpIntent": function (intent, session, response) {
        response.ask("You can say hello to me!", "You can say hello to me!");
    }
};

// Create the handler that responds to the Alexa Request.
exports.handler = function (event, context) {
    // Create an instance of the Hello skill.
    var skill = new Hello();
    skill.execute(event, context);
};