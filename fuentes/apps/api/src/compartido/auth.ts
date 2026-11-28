import { betterAuth } from 'better-auth';
import { prismaAdapter } from 'better-auth/adapters/prisma';
import {prisma } from './db.js';

export const auth = betterAuth({
    baseURL: process.env.BETTER_AUTH_URL,
    secret: process.env.BETTER_AUTH_SECRET,
    trustedOrigins: [process.env.WEB_URL ?? 'http://localhost:5173'],

    database: prismaAdapter(prisma, {provider: 'sqlserver'}),

    emailAndPassword: {enabled: true},

    user:{
         modelName: 'auth_user',
        additionalFields: {
            usuarioId:{type: 'number', required: false, input:false},
    },
    },
    session: { modelName: 'auth_session' },
account: { modelName: 'auth_account' },
verification: { modelName: 'auth_verification' },

});