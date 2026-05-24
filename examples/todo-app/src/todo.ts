export interface Todo {
  id: string;
  title: string;
  done: boolean;
  createdAt: Date;
}

export class TodoStore {
  private items = new Map<string, Todo>();

  add(title: string): Todo {
    const id = crypto.randomUUID();
    const todo: Todo = { id, title, done: false, createdAt: new Date() };
    this.items.set(id, todo);
    return todo;
  }

  complete(id: string): void {
    const todo = this.items.get(id);
    if (!todo) throw new Error(`todo not found: ${id}`);
    todo.done = true;
  }

  list(): Todo[] {
    return Array.from(this.items.values());
  }
}
