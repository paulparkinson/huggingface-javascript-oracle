package oracleai;

import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.io.ClassPathResource;

import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@SpringBootApplication
public class HuggingFaceFromOracleDatabaseApplication {


    public static void main(String[] args) throws Exception{
		System.out.println("HuggingFaceFromOracleDatabaseApplication " + new HuggingFaceFromOracleDatabaseApplication().uploadwallet());
	}

	private static Connection getConnection() throws SQLException {

		PoolDataSource pool = PoolDataSourceFactory.getPoolDataSource();
		pool.setURL(System.getenv("SPRING_DATASOURCE_URL"));
		pool.setUser(System.getenv("SPRING_DATASOURCE_USERNAME"));
		pool.setPassword(System.getenv("SPRING_DATASOURCE_PASSWORD"));
		pool.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
		Connection conn = pool.getConnection();
		System.out.println("HuggingFaceFromOracleDatabaseApplication.getConnection" + conn);
		return conn;
	}


	 String uploadwallet()
			throws Exception {
		Connection conn = getConnection();
		InputStream resourceAsStream = new ClassPathResource("ewallet.p12").getInputStream();
		CallableStatement cstmt = conn.prepareCall("{call write_file(?,?,?)}");
		cstmt.setString(1, "DATA_PUMP_DIR");
		cstmt.setString(2, "ewallet.p12");
		cstmt.setBinaryStream(3, resourceAsStream  );
		cstmt.execute();
		return "ewallet.p12 wallet uploaded to DATA_DUMP_DIR";
	}
	// Note that you can verify upload success by running
	//     select * from dba_directories where directory_name='DATA_PUMP_DIR';
	// and checking the contents either via query or, in the case of container image by
	//     docker exec 48666ed5ade0 ls -al /opt/oracle/admin/FREE/dpdump/FB9997ED60890BBDE0536402000AF33F/ewallet.p12

}
