import time
import logging
import sys

def main():
    # Create a logger
    logger = logging.getLogger("my_app")
    logger.setLevel(logging.DEBUG)

    # Create formatter
    formatter = logging.Formatter('%(asctime)s [%(levelname)s]: %(message)s')

    # Create console handlers for stdout and stderr
    stdout_handler = logging.StreamHandler(sys.stdout)
    stdout_handler.setLevel(logging.INFO)
    stdout_handler.setFormatter(formatter)

    stderr_handler = logging.StreamHandler(sys.stderr)
    stderr_handler.setLevel(logging.ERROR)
    stderr_handler.setFormatter(formatter)

    # Add the handlers to the logger
    logger.addHandler(stdout_handler)
    logger.addHandler(stderr_handler)

    counter = 0

    while True:
        counter += 1
        logger.info("This is a regular log message.")
        if counter % 3 == 0:  # Every 30 seconds
            logger.error("This is an error log message.")
        time.sleep(10)

if __name__ == '__main__':
    main()