import { TodoStore } from "./todo.js";

const store = new TodoStore();

const [, , command, ...rest] = process.argv;

switch (command) {
  case "add": {
    const todo = store.add(rest.join(" "));
    console.log(`added: ${todo.id} ${todo.title}`);
    break;
  }
  case "list": {
    for (const todo of store.list()) {
      console.log(`${todo.done ? "[x]" : "[ ]"} ${todo.id} ${todo.title}`);
    }
    break;
  }
  default:
    console.error("usage: cli.ts add <title> | list");
    process.exit(1);
}
