import { t } from 'elysia'

export namespace Chatbot {
    // Define a DTO for Elysia validation
    export const chatbotBody = t.Object({
        message: t.String(),
    })


    export type chatbotBody = typeof chatbotBody.static

    export const chatbotResponse = t.Object({
        message: t.String()
    })

    export type chatbotResponse = typeof chatbotResponse.static

    export const signInInvalid = t.Literal('Invalid username or password')
    export type signInInvalid = typeof signInInvalid.static
}