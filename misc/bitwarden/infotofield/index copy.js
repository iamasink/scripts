// a script to modify vaultwarden SQLite database to have the old created_at and updated_at fields, which arent imported correctly

const fs = require('fs');
const path = require('path');


const filepath = './bitwarden_export.json';
// idk if this is actually necessary or if bitwarden exports the correct ids, but im not fixing this now
const filepath2 = "./keyguard_export.json"

const jsonFilePath = filepath
const jsonData = fs.readFileSync(jsonFilePath, 'utf8');
const jsonObject = JSON.parse(jsonData);

const jsonFilePath2 = filepath2
const jsonData2 = fs.readFileSync(jsonFilePath2, 'utf8');
const jsonObject2 = JSON.parse(jsonData2);


let total = 0
let failed = 0
let final = ""

jsonObject.items.forEach(item => {
    console.log(`Item Name: ${item.name}, Item ID: ${item.id}`);
    const matchingItem = jsonObject2.items.find(obj => obj.name === item.name);
    if (matchingItem) {
        console.log(`Matching Item ID in second object: ${matchingItem.id}`);
        const createdAt = item.creationDate
        const updatedAt = item.revisionDate
        console.log(`Created At: ${createdAt}`);
        // format dates
        const createdAtFormatted = new Date(createdAt).toISOString().slice(0, 19).replace('T', ' ');
        const updatedAtFormatted = new Date(updatedAt).toISOString().slice(0, 19).replace('T', ' ');

        final += `UPDATE "main"."ciphers" SET created_at='${createdAtFormatted}', updated_at='${updatedAtFormatted}' WHERE uuid='${matchingItem.id}';\n`;
        total++;
    } else {
        console.log('No matching item found in second object.');
        failed++;
    }

});

console.log(`Total: ${total}`);
console.log(`Failed: ${failed}`);
console.log(`Final: ${final}`);