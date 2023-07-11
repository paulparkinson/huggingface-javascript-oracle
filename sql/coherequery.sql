create or replace mle module cohere_module
language javascript as

import "mle-js-fetch";
import "mle-js-oracledb";

export async function cohereDemo(apiToken) {

    if (apiToken === undefined) {
        throw Error("must provide an API token");
    }

    const modelId = "generate";
    const restAPI = `https://api.cohere.ai/v1/${modelId}`;

    const headers = {
                         accept: 'application/json',
                         'content-type': 'application/json',
                         "Authorization": `Bearer ${apiToken}`
                       };

    const payload = {
     max_tokens: 20,
     return_likelihoods: 'NONE',
     truncate: 'END',
     prompt: 'Please explain to me how LLMs work'
    };

    const resp = await fetch(
        restAPI, {
            method: "POST",
            headers: headers,
            body: JSON.stringify(payload),
            credentials: "include"
        }
    );
    const resp_json = await resp.json();

    session.execute(
        `INSERT INTO COHEREJSON (id) VALUES (:resp_json)`,
           [ JSON.stringify(resp_json) ]
    );

}
/

create or replace procedure coherequery(
    p_API_token varchar2
) as mle module cohere_module
signature 'cohereDemo(string)';
/

-- this is how you can test the API call
begin
    utl_http.set_wallet('system:');
    coherequery('[yourcoheretokenhere]');
end;
/
