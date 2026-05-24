import { test } from "node:test";
import assert from "node:assert/strict";
import { TodoStore } from "../src/todo.js";

test("add returns the created todo", () => {
  const store = new TodoStore();
  const todo = store.add("write a test");
  assert.equal(todo.title, "write a test");
  assert.equal(todo.done, false);
});

test("complete marks the todo done", () => {
  const store = new TodoStore();
  const todo = store.add("write a test");
  store.complete(todo.id);
  const [reloaded] = store.list();
  assert.equal(reloaded.done, true);
});
