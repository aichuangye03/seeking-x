import { supabase } from "./database.js";
import { createTweet } from "./tweet-writer.js";


async function testWrite() {


    const { data: account, error } =
        await supabase
        .from("x_accounts")
        .select("id,username")
        .limit(1)
        .single();



    if(error){

        console.error(error);

        return;

    }



    console.log(
        "Using account:",
        account
    );



    const tweet =
        await createTweet({

            account_id: account.id,

            external_id:
            "test_" + Date.now(),

            content:
            "Test tweet from Seeking-X Collector",

            tweet_url:
            "https://x.com/" + account.username

        });



    console.log(
        "Tweet inserted:"
    );


    console.log(tweet);


}



testWrite();
