import { supabase } from "./database.js";


async function testConnection() {

  const { data, error } = await supabase
    .from("x_accounts")
    .select(
      "username,priority,monitor_level"
    )
    .limit(10);


  if (error) {

    console.error(error);

    return;

  }


  console.log(
    "Supabase connection successful"
  );


  console.log(data);

}


testConnection();
