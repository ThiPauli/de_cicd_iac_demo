import requests


def get_jsonplaceholder_posts_api() -> list:
    endpoint = "https://jsonplaceholder.typicode.com/posts"
    response = requests.get(endpoint)
    response.raise_for_status()  # Raise an exception for HTTP errors
    return response.json()


def get_jsonplaceholder_comments_api() -> list:
    endpoint = "https://jsonplaceholder.typicode.com/comments"
    response = requests.get(endpoint)
    response.raise_for_status()  # Raise an exception for HTTP errors
    return response.json()
