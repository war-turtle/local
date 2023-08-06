// const axios = require('axios');
import axios from 'axios';
import clipboardy from 'clipboardy';
// const clipboardy = require('clipboardy');

// Hypothesis API endpoint for retrieving annotations
const apiUrl = 'https://api.hypothes.is/api/search';

// Set your Hypothesis API token
const apiToken = '6879-iEfpTzve9Knq5PvEG8Ks7KUkIs2H04MstlKYdzRNeXQ';

const args = process.argv.splice(2);

// URL of the webpage or document with the highlights
// const pageUrl = 'https://cp-algorithms.com/data_structures/segment_tree.html';
const pageUrl = args[0];

// const regex = /(<math.*?\$\u200A)|(\u200A\u200A)|(\u2061)/g;
const regex = /(\u200A\u200A.*?\$)|(\$\u200A)|(\u2061)/g;

// Function to retrieve highlights using Hypothesis API
async function getHighlights() {
  try {
    const response = await axios.get(apiUrl, {
      headers: {
        Authorization: `Bearer ${apiToken}`,
      },
      params: {
        url: pageUrl,
        limit: 24, // Maximum number of annotations to retrieve (adjust as needed)
      },
    });

    const annotations = response.data.rows;

    // Extract highlight text and other relevant information
    const highlights = annotations
      .filter(annotation => annotation.target[0].selector)
      .map(annotation => {
        const highlightText = annotation.target[0].selector.find(selector => selector.type === 'TextQuoteSelector').exact;
        const user = annotation.user;

        // const regex = /<math[^>]*>.*?<\/math>|(\$[^$]*\$_)/g;

        return {
          highlight: highlightText.replace(regex, ''),
          // highlight: highlightText,
          user: user,
        };
      });

    // Print the extracted highlights
    console.log('Extracted Highlights:');
    highlights.forEach((highlight, index) => {
      console.log(`Highlight ${index + 1}: ${highlight.highlight}`);
    });

    clipboardy.writeSync(highlights.map(e => "* " + e.highlight).reverse().join('\n'))
    // clipboardy.writeSync(String.fromCharCode(8230))

    // You can perform further processing or save the extracted highlights as needed

  } catch (error) {
    console.error('Error retrieving highlights:', error.message);
  }
}

// Call the function to retrieve the highlights
getHighlights();
