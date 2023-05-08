"use strict";
const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  try {
    const results = await dynamodb.scan({
      TableName: "ItemTable"
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify(results.Items),
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