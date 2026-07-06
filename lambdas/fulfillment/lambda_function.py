import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Lex Fulfillment Lambda triggered")
    logger.info(json.dumps(event))
    
    intent_name = event['sessionState']['intent']['name']
    
    if intent_name in ["WelcomeIntent", "FallbackIntent"]:
        return {
            "sessionState": {
                "dialogAction": {
                    "type": "Close"
                },
                "intent": {
                    "name": intent_name,
                    "state": "Fulfilled"
                }
            },
            "messages": [{
                "contentType": "PlainText",
                "content": "Hello! Welcome to Optum Support. How can I help you today?"
            }]
        }
    
    # Default response for other intents
    return {
        "sessionState": {
            "dialogAction": {
                "type": "Delegate"
            },
            "intent": event['sessionState']['intent']
        }
    }