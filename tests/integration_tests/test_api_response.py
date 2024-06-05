from typing import List

import pytest
from pydantic import BaseModel, EmailStr, TypeAdapter, ValidationError

from include.utils import (
    get_jsonplaceholder_comments_api,
    get_jsonplaceholder_posts_api,
)


# Define the Pydantic model for validation to the posts endpoint
class Post(BaseModel):
    userId: int
    id: int
    title: str
    body: str


# Define the Pydantic model for validation to the comments endpoint
class Comment(BaseModel):
    postId: int
    id: int
    name: str
    email: EmailStr
    body: str


def test_jsonplaceholder_request_api():
    # Call the get_jsonplaceholder_posts_api function
    api_response = get_jsonplaceholder_posts_api()
    post_list_adapter = TypeAdapter(List[Post])

    # Validate the response with Pydantic
    try:
        # Validate the API response object against the model
        posts = post_list_adapter.validate_python(api_response)
        assert isinstance(
            posts, list
        ), "The validated response posts is not a list"
        assert all(
            isinstance(post, Post) for post in posts
        ), "Not all items in the list are Post instances"
    except ValidationError as e:
        pytest.fail(f"API response validation failed for posts: {e}")


def test_jsonplaceholder_comments_api():
    # Call the get_jsonplaceholder_comments_api function
    api_response = get_jsonplaceholder_comments_api()
    comment_list_adapter = TypeAdapter(List[Comment])

    # Validate the response with Pydantic
    try:
        # Validate the API response object against the model
        comments = comment_list_adapter.validate_python(api_response)
        assert isinstance(
            comments, list
        ), "The validated response comments is not a list"
        assert all(
            isinstance(comment, Comment) for comment in comments
        ), "Not all items in the list are Comment instances"
    except ValidationError as e:
        pytest.fail(f"API response validation failed for comments: {e}")


if __name__ == "__main__":
    pytest.main()
