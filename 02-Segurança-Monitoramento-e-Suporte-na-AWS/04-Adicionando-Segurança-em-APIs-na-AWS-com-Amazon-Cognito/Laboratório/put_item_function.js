const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const { id, price } = JSON.parse(event.body);

    const params = {
      TableName: 'Items',
      Item: {
        id: id,
        price: price
      }
    };

    await dynamodb.put(params).promise();

    return {
      statusCode: 200,
      body: JSON.stringify('Item inserido com sucesso!')
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify(err)
    };
  }
};