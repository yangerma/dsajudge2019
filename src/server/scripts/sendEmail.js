import './common';
import User from '/model/user';
import nodemailer from 'nodemailer';
import bcrypt from 'bcrypt';
import prompt from 'prompt';
import randomString from 'randomstring';
import {promisify} from 'bluebird';

const main = async () => {

    prompt.start();
    const result = await promisify(prompt.get)({
        properties: {
            account: {
                description: `Your NTU account, don't input @ntu.edu.tw\n (The mail would be send by your account)`,
                pattern: /^\w+$/,
                message: 'Input a valid NTU account',
                required: true,
            },
            password: {
                hidden: true,
            }
        }
    });

    const smtpConfig = {
        host: 'smtps.ntu.edu.tw',
        port: 465,
        secure: true,
        auth: {
            user: result.account,
            pass: result.password,
        }
    };
    const mailTransporter = nodemailer.createTransport(smtpConfig);
    await newUser("email_email", "pass_pass", mailTransporter);
    console.log('Ended...');
};

const newUser = async (email, randPass, transporter) => {
    const text = (
`Welcome to DSA2019, this email is to inform you that your DSA Judge account has been created.
Here is your account and temporary password. (You can change your password after logging in.)

- Account: ${email}
- Password: ${randPass}

Head on to https://dsa1.csie.org and try it!
` );

    const mailOptions = {
        from: '"DSA2019" <dsa1@csie.org>',
        to: email,
        subject: '[DSA2019]Your DSA Judge Account',
        text,
    };
	
    await new Promise( (resolve, reject) => {
        transporter.sendMail(mailOptions, (err, result) => {
            if (err) return reject(err);
            resolve(result);
        });
    } );
    //await user.save();
	console.log(`${email} successfully sended.`);
};

if (require.main === module) {
    main();
}
