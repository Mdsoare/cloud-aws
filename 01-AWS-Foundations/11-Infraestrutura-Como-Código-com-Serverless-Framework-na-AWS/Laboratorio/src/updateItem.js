"use strict";
const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  try {
    const { itemStatus } = JSON.parse(event.body);
    const { id } = event.pathParameters;

    await dynamodb.update({
      TableName: "ItemTable",
      Key: { id },
      UpdateExpression: 'set itemStatus = :itemStatus',
      ExpressionAttributeValues: {
        ':itemStatus': itemStatus,
      },
      ReturnValues: "ALL_NEW",
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ msg: 'Item updated' }),
    };
  } catch (error) {
    console.log(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "An error occurred",
      }),
    };
  }
};