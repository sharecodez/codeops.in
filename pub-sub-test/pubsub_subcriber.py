# import logging
# from concurrent import futures
# from google.cloud import pubsub_v1

# logging.basicConfig(level=logging.INFO)

# project_id = "kloudping"
# subscription_id = "my-python-topic-sub"

# subscriber = pubsub_v1.SubscriberClient()
# # The `subscription_path` method creates a fully qualified identifier
# # in the form `projects/{project_id}/subscriptions/{subscription_id}`
# subscription_path = subscriber.subscription_path(project_id, subscription_id)

# def callback(message):
#     logging.info("Received %s", message)
#     message.ack()

# future = subscriber.subscribe(subscription_path, callback=callback)

# with subscriber:
#     try:
#         future.result(timeout=5)
#     except futures.TimeoutError:
#         future.cancel()  # Trigger the shutdown.
#         future.result()  # Block until the shutdown is complete.