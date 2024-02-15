import json

def lambda_handler(event, context):
    print('event',event)
    print('context',context)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
