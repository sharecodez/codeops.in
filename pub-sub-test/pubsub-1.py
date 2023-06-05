# from google.cloud import pubsub_v1

# project_id = "kloudping"
# topic_id = "my-python-topic"

# publisher = pubsub_v1.PublisherClient()
# # The `topic_path` method creates a fully qualified identifier
# # in the form `projects/{project_id}/topics/{topic_id}`
# topic_path = publisher.topic_path(project_id, topic_id)

# # The message must be a bytestring.
# message1 = b"Hello"

# _message2 = "World!"
# message2 = _message2.encode("utf-8")

# # When you publish a message, the client returns a future.
# future1 = publisher.publish(topic_path, message1)
# print(future1.result())
# # 3831040081518609

# future2 = publisher.publish(topic_path, message2)
# print(future2.result())
# # 3831025373039544