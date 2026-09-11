import { supabase } from "./database.js";


interface TweetInput {

    account_id: string;

    external_id: string;

    content: string;

    tweet_url?: string;

}



export async function createTweet(
    tweet: TweetInput
) {


    const { data, error } = await supabase
        .from("tweets")
        .insert({

            account_id: tweet.account_id,

            external_id: tweet.external_id,

            content: tweet.content,

            tweet_url: tweet.tweet_url,

            source: "x",

            analysis_status: "pending"

        })
        .select()
        .single();



    if (error) {

        throw error;

    }



    return data;

}
