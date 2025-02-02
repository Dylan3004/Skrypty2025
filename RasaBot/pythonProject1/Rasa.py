import discord
import asyncio
from rasa.core.agent import Agent
from rasa.core.utils import EndpointConfig

# Token Discord bota
DISCORD_TOKEN = 'xxx'

agent = Agent.load('models/dialogue')

# Inicjalizacja klienta Discord
intents = discord.Intents.default()
intents.message_content = True

client = discord.Client(intents=intents)

@client.event
async def on_message(message):
    if message.author == client.user:
        return

    user_message = message.content
    print(f"Received message: {user_message}")

    responses = await agent.handle_text(user_message)

    if responses:
        response_text = responses[0]['text']
        await message.channel.send(response_text)

@client.event
async def on_ready():
    print(f'Logged in as {client.user}')

# Uruchom bota Discord
client.run(DISCORD_TOKEN)
