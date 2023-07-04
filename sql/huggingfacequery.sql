declare
  ctx dbms_mle.context_handle_t;
  SNIPPET CLOB;
begin
  ctx := dbms_mle.create_context();
  SNIPPET := q'~
  (async () => {
   await import('mle-js-fetch');
   const oracledb = require("mle-js-oracledb");
   const payload = "{\"inputs\": \"The answer to the universe is [MASK].\"}" ;
   const modelId = 'bert-base-uncased';
   const apiToken = 'hf_[yourhuggingfacetoken]';
   const headers = { 'Authorization': `Bearer ${apiToken}` };
   const API_URL = `https://api-inference.huggingface.co/models/${modelId}`;
   const answer = await fetch(API_URL, {
                  			method: 'POST',
                  			headers: headers,
                  			body: JSON.stringify(payload),
                  			credentials: 'include'
                  		}).then(response => response.json());
   const insertJsonSql = 'INSERT INTO HUGGINGFACEJSON (id) VALUES (:jsonAnswer)';
   const jsonAnswer = JSON.stringify(answer, undefined, 4);
   await  oracledb.defaultConnection().execute(insertJsonSql, {jsonAnswer});
   console.log(JSON.stringify(answer, undefined, 4));
  })();
  ~';
  dbms_mle.eval(ctx, 'JAVASCRIPT', SNIPPET, options =>'js_mode=module');
  dbms_mle.drop_context(ctx);
end;
/
