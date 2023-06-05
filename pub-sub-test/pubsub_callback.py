# import logging
# from concurrent import futures

# logging.basicConfig(level=logging.INFO)

# def get_callback(future, message):
#     def callback(future):
#         try:
#             logging.info("Published message %s.", future.result(timeout=1))
#         except futures.TimeoutError as exc:
#             print("Publishing %s timeout: %r", message, exc)
#     return callback

# publish_futures = []

# for i in range(1, 5):
#     _message = f"message {i}"
#     message = _message.encode("utf-8")
    
#     future = publisher.publish(topic_path, message)
#     future.add_done_callback(get_callback(future, message))
    
#     publish_futures.append(future)

# # Wait for all the futures to resolve before exiting.
# futures.wait(publish_futures, return_when=futures.ALL_COMPLETED)