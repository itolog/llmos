import { Elysia } from "elysia";
import {chatbotController} from "./modules/chatbot";

const app = new Elysia().use(chatbotController).listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
