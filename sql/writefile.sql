CREATE OR REPLACE PROCEDURE write_file(
  directory_name IN VARCHAR2, file_name IN VARCHAR2,
  contents IN BLOB
) IS l_file UTL_FILE.file_type;
l_data_len INTEGER;
l_buffer RAW(32000);
l_pos INTEGER := 1;
l_amount INTEGER := 32000;
BEGIN l_data_len := DBMS_LOB.getlength(contents);
l_file := UTL_FILE.FOPEN(
  directory_name, file_name, 'wb', l_amount
);
WHILE l_pos < l_data_len LOOP DBMS_LOB.read(
  contents, l_amount, l_pos, l_buffer
);
UTL_FILE.PUT_RAW(l_file, l_buffer, TRUE);
l_pos := l_pos + l_amount;
END LOOP;
UTL_FILE.FCLOSE(l_file);
EXCEPTION WHEN OTHERS THEN UTL_FILE.FCLOSE(l_file);
RAISE;
END write_file;
/
