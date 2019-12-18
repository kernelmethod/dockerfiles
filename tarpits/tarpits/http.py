#!/usr/bin/env python3
"""
HTTP tarpit to slow down attackers
"""

import asyncio
import logging
import logging.config
import random
from yaml import load, Loader

async def handler(_reader, writer):
    peername, port = writer.get_extra_info("peername")
    logger.info(f"{peername}:{port} connected")
    writer.write(b"HTTP/1.1 200 OK\r\n")
    try:
        while True:
            await asyncio.sleep(5)
            header = random.randint(0, 2**32)
            value = random.randint(0, 2**32)
            writer.write(b"X-%x: %x\r\n" % (header, value))
            await writer.drain()
    except ConnectionResetError:
        pass
    logger.info(f"{peername}:{port} disconnected")

async def main():
    server = await asyncio.start_server(handler, "0.0.0.0", 8080)
    logger.info("Started HTTP tarpit")
    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    with open("logging.yaml", "r") as conf:
        logging.config.dictConfig(
            load(conf, Loader=Loader)
        )

    logger = logging.getLogger("HTTP tarpit")

    asyncio.run(main())
