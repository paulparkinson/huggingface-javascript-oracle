begin
  -- Allow all hosts for HTTP/HTTP_PROXY
  dbms_network_acl_admin.append_host_ace(
    host =>'*',
    -- need at least 'connect' privilege
    ace => xs$ace_type(privilege_list => xs$name_list('http', 'http_proxy'),
    principal_name => upper('aijs'),
    principal_type => xs_acl.ptype_db));
 -- Allow wallet access
 dbms_network_acl_admin.append_wallet_ace(
 wallet_path => 'file:/opt/oracle/admin/FREE/dpdump/FB9997ED60890BBDE0536402000AF33F',
 ace => xs$ace_type(privilege_list =>
 xs$name_list('use_client_certificates', 'use_passwords'),
 principal_name => upper('aijs'),
 principal_type => xs_acl.ptype_db));
end;
/
show errors

execute UTL_HTTP.SET_WALLET('file:/opt/oracle/admin/FREE/dpdump/FB9997ED60890BBDE0536402000AF33F', '[WALLET_PASSWORD]');
