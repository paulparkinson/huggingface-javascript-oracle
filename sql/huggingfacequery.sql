create or replace mle module huggingface_module
language javascript as

import "mle-js-fetch";
import "mle-js-oracledb";

export async function huggingfaceDemo(apiToken) {

    if (apiToken === undefined) {
        throw Error("must provide an API token");
    }

    const payload = {
        inputs: "The answer to the universe is [MASK]."
    };
    const modelId = "bert-base-uncased";

    const headers = {
        "Authorization": `Bearer ${apiToken}`
    };

    const restAPI = `https://api-inference.huggingface.co/models/${modelId}`;

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
        `INSERT INTO HUGGINGFACEJSON (id) VALUES (:resp_json)`,
        [ JSON.stringify(resp_json) ]
    );
}
/

create or replace procedure huggingfacequery(
    p_API_token varchar2
) as mle module huggingface_module
signature 'huggingfaceDemo(string)';
/

-- this is how you can test the API call
begin
    utl_http.set_wallet('system:');
    huggingfacequery('[hf_yourhuggingfacetokenhere]');
end;
/
