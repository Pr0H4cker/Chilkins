//this is an event listener
client.on('message', message => {
  // If message is ping
  if (message.content === 'yo') {
    // Send pong back
    message.channel.send('yo wut up');
  }
});
