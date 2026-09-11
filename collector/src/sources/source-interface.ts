export interface SourceTweet {

    external_id: string;

    content: string;

    tweet_url?: string;

    published_at?: string;

    raw_payload?: unknown;

}



export interface DataSource {


    name: string;


    fetchTweets(
        username:string
    ): Promise<SourceTweet[]>;


}
