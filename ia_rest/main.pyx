#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" start server """

import asyncio
from asyncio                 import AbstractEventLoopPolicy
import os

from fastapi                 import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from structlog               import get_logger
import uvicorn
from uvloop                  import EventLoopPolicy

logger = get_logger()

def set_policy_if_not_nt()->None:
	""" https://stackoverflow.com/questions/72681045/psycopg-asyncio-set-even-loop-policy """

	if (os.name == "nt"):
		return

	policy:AbstractEventLoopPolicy = EventLoopPolicy()
	asyncio.set_event_loop_policy(policy)

def start_server(app: FastAPI, host:str, port: int,) -> None:
	set_policy_if_not_nt()
	app.add_middleware(
		CORSMiddleware,
		allow_origins=['*'],
		allow_credentials=True,
		allow_methods=["*"],
		allow_headers=["*"],
	)
	uvicorn.run(app, host=host, port=port)

def _main(host:str, port:int,)->None:
	app:FastAPI = FastAPI()
	start_server(app=app, host=host, port=port,)

def main()->None:
	host    :str =     os.getenv('HOST', '0.0.0.0')
	port    :int = int(os.getenv('PORT', '4444'))
	_main(host=host, port=port,)

if __name__ == '__main__':
	main()

__author__:str='you.com' # NOQA
