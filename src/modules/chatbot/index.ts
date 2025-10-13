import { Elysia } from "elysia";
import { Chatbot } from "./model";

export const chatbotController = new Elysia({ prefix: "/chatbot" }).post(
  "/",
  async ({ body }) => {
    console.log(body);

    return {
      message: "OK",
    };
  },
  {
    body: Chatbot.chatbotBody,
    response: Chatbot.chatbotResponse,
  },
);
