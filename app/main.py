import os
import time
import uuid

import psycopg
from fastapi import FastAPI
from pydantic import BaseModel

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://app:app@db:5432/app",
)


class Item(BaseModel):
    name: str


app = FastAPI(title="FastAPI + Postgres", version="1.0.0")

_conn: psycopg.Connection | None = None


def get_conn() -> psycopg.Connection:
    global _conn
    if _conn is None:
        _conn = psycopg.connect(DATABASE_URL, connect_timeout=5)
        with _conn.cursor() as cur:
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS items (
                    id   UUID PRIMARY KEY,
                    name TEXT NOT NULL
                )
                """
            )
        _conn.commit()
    return _conn


@app.on_event("startup")
def startup() -> None:
    for attempt in range(10):
        try:
            get_conn()
            return
        except psycopg.OperationalError:
            time.sleep(2)
    raise RuntimeError("Could not connect to database")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/items")
def list_items() -> list[dict]:
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT id, name FROM items ORDER BY name")
        return [{"id": str(row[0]), "name": row[1]} for row in cur.fetchall()]


@app.post("/items", status_code=201)
def create_item(item: Item) -> dict:
    conn = get_conn()
    item_id = uuid.uuid4()
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO items (id, name) VALUES (%s, %s)",
            (item_id, item.name),
        )
    conn.commit()
    return {"id": str(item_id), "name": item.name}