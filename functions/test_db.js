const fs = require('fs');

async function main() {
  const configFile = JSON.parse(fs.readFileSync('/home/h/.config/configstore/firebase-tools.json', 'utf8'));
  const refreshToken = configFile.tokens?.refresh_token || configFile.refresh_token;

  if (!refreshToken) {
    console.error("No refresh token found in config");
    return;
  }

  // Request an access token from oauth2 endpoint using refresh token
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com',
      grant_type: 'refresh_token',
      refresh_token: refreshToken
    })
  });
  const data = await response.json();
  const accessToken = data.access_token;
  if (!accessToken) {
    console.error("Failed to get access token", data);
    return;
  }

  // Fetch Firestore document using REST API
  const url = `https://firestore.googleapis.com/v1/projects/ecommerce-test-54853/databases/(default)/documents/zoomAccounts`;
  const res = await fetch(url, {
    headers: { 'Authorization': `Bearer ${accessToken}` }
  });
  const docs = await res.json();
  console.log("Documents in zoomAccounts:");
  console.log(JSON.stringify(docs, null, 2));
}

main().catch(console.error);
