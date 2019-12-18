#!/usr/bin/env python3

import asyncio
import random
import logging
import logging.config
from yaml import load, Loader

async def handler(_reader, writer):
    peername, port = writer.get_extra_info("peername")
    logger.info(f"{peeername}:{port} connected")
    try:
        while True:
            await asyncio.sleep(10)
            writer.write(b"%x\r\n" % random.randint(0, 2**32))
            await writer.drain()
    except ConnectionResetError:
        pass
    logger.info(f"{peername}:{port} disconnected")

async def main():
    server = await asyncio.start_server(handler, "0.0.0.0", 2222)
    logger.info("Started SSH tarpit")
    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    with open("logging.yaml", "r") as conf:
        logging.config.dictConfig(
            load(conf, Loader=Loader)
        )

    logger = logging.getLogger("SSH tarpit")

    asyncio.run(main())
