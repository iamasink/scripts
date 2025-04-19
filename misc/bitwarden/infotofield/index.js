

const fs = require('fs');
const path = require('path');


const filepath = './bitwarden_export.json';
const filename = path.basename(filepath);
const filedir = path.dirname(filepath);


const jsonFilePath = filepath
const jsonData = fs.readFileSync(jsonFilePath, 'utf8');
const jsonObject = JSON.parse(jsonData);

// list json stuff
// console.log(jsonObject);

const fieldstocheck = [
    'name',
    'user',
    'username',
    'email',
    'dob',
    'birthdate',
    'address',
    'phone',
    'phone number',
    'phone no',
    'number',
    'account number',
    'pet',
    'ssn',
    'city',
    'state',
    'nickname',
]

const seperators = [
    ':',
    '-',
    ' ',
    '=',
]

const disallowedfields = [
    "recovery",
    "code",
    "@",
    "generated"
]

const disallowedcontent = [
    "recovery",
    "code",
    "is",
    "generated",
    ",",
    "could not",
    "deleted",
    "banned",
    "removed",
    "requested",
    "not found",
]

const disalloweditems = [
    "recovery",
    "sponsorblock",
    "dearrow",
    "de-arrow",
    "de arrow",
    "sponsor block",
    "key"
]

// eg fields
/*
      "fields": [
        {
          "name": "email",
          "value": "asdfasdfasdfasdfasdf@gmail.com",
          "type": 0,
          "linkedId": null
        }
      ],
      */

let modified_items = 0
let new_fields = 0
let skipped_items = 0
let disallowed_contents_items = 0
let disallowed_field_items = 0




// Iterate over jsonObject.items
if (jsonObject.items && Array.isArray(jsonObject.items)) {
    jsonObject.items.forEach(item => {
        if (item.notes) {
            let changed = false;
            console.log(`\n📋 Item: ${item.name}`);
            // console.log(`📝 Note: ${item.notes}`);
            if (item.type === 2) {
                console.log(`🐈 Type: ${item.type} (Secure Note). Skipping`); // Type 2 is a Secure Note
                skipped_items++
                return
            }
            if (item.type === 3) {
                console.log(`🐈 Type: ${item.type} (Identity). Skipping`); // Type 3 is an Identity
                skipped_items++
                return
            }
            if (item.type === 4) {
                console.log(`🐈 Type: ${item.type} (Card). Skipping`); // Type 4 is a Card
                skipped_items++
                return
            }
            if (item.name && disalloweditems.some(word => item.name.toLowerCase().includes(word))) {
                console.log(`🔘 Type: ${item.name} contains Disallowed item name. Skipping`);
                skipped_items++
                return
            }

            // Split the note into lines
            const lines = item.notes.split('\n');
            // For each line, check if it starts with a field name
            lines.forEach(line => {
                let foundmatch = false;

                const match = line.match(/^(.*?)\s*(:|-)\s+(.*)$/i);
                if (match) {
                    const fieldName = match[1].trim();
                    const fieldValue = match[3].trim();
                    // if fieldname has word from disallowed, skip
                    if (disallowedfields.some(word => fieldName.toLowerCase().includes(word))) {
                        // console.log(`💢 Disallowed field name: ${fieldName}`);
                        disallowed_field_items++
                        return;
                    } else if (disallowedcontent.some(word => fieldValue.toLowerCase().includes(word))) {
                        // console.log(`💢 Disallowed field content: ${fieldValue}`);
                        disallowed_contents_items++
                        return;
                    }
                    else {
                        // Log first part of field value
                        console.log(`🔑 Field: ${fieldName}, 📄 Value: ${fieldValue}`);
                        item.fields ? item.fields : item.fields = [];
                        item.fields.push({ name: fieldName, value: fieldValue, type: 0, linkedId: null });
                        // remove from notes
                        item.notes = item.notes.replace(line, '').trim();
                        foundmatch = true;
                        new_fields++
                        changed = true;
                    }
                } else {
                    console.log(`❔ No separator found for line: ${line}`);
                    // Check if the line starts with a field name
                    const fieldName = fieldstocheck.find(field => line.toLowerCase().startsWith(field.toLowerCase()));
                    if (fieldName) {
                        const sep = seperators.find(s => line.includes(s));
                        const fieldValue = sep ? line.split(sep).slice(1).join(sep).trim() : '';
                        // if fieldname has word from disallowed, skip
                        if (disallowedcontent.some(word => fieldValue.toLowerCase().includes(word))) {
                            // console.log(`💢 Disallowed field content: ${fieldValue}`);
                            disallowed_contents_items++
                            return;
                        }
                        else {

                            console.log(`2 🔑 Field: ${fieldName}, 📄 Value: ${fieldValue}`);
                            item.fields ? item.fields : item.fields = [];
                            item.fields.push({ name: fieldName, value: fieldValue, type: 0, linkedId: null });
                            // remove from notes
                            item.notes = item.notes.replace(line, '').trim();
                            foundmatch = true;
                            new_fields++
                            changed = true;
                        }
                    }
                }

                if (foundmatch) {
                    console.log(`✔️ matches found!`)
                    // console.log(`📝 Modified Note: "${item.notes}"`);


                } else {
                    // console.log(`❌ No matches found for line: ${line}`);
                }


            });
            if (changed) {
                modified_items++
                // console.log(`\n📝 Modified Note: "${item.notes}"`);
            } else {
                console.log(`❌ No changes made to item: ${item.name}`);
            }
        }
    });
}

// Log the number of modified items
console.log(`\n🔧 Modified items: ${modified_items}`)
console.log(`\n🔧 New fields added: ${new_fields}`);
console.log(`\n🔧 Skipped items: ${skipped_items}`)
console.log(`\n🔧 Disallowed field items: ${disallowed_field_items}`)
console.log(`\n🔧 Disallowed contents items: ${disallowed_contents_items}`);


// Write the modified jsonObject to a new file


const outputFilePath = path.join(filedir, filename + 'modified_output.json');
fs.writeFileSync(outputFilePath, JSON.stringify(jsonObject, null, 2), 'utf8');
console.log(`\n✅ Modified JSON written to ${outputFilePath}`);
