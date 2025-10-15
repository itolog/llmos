import { Elysia } from "elysia";
import { openapi } from "@elysiajs/openapi";
import { chatbotController } from "./modules/chatbot";

const app = new Elysia()
  .use(openapi())
  .get("/", "Hello World!!")
  .use(chatbotController)
  .listen({ port: process.env.PORT, hostname: process.env.HOST });

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`,
);
