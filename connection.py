# Import the driver library for connecting postgresql
import psycopg2
# from config import config


class Postgre:
    conn = None

    @staticmethod
    def connect():
        print("trying connection...")
        
        
        """ Connect to the PostgreSQL database server """
        if Postgre.conn is None:
            conn = None
            try:
                # read connection parameters
                # params = config()
                params = {'host': 'localhost',
                          'database': 'resolvehub',
                          'user': 'superuser',
                          'password': 'superuser',
                          'port': 5432
                          }

                # connect to the PostgreSQL server
                print('Connecting to the PostgreSQL database...')
                conn = psycopg2.connect(database='resolvehub',host='localhost',user='superuser',password='superuser',port='5432')
                # conn = psycopg2.connect('postgresql://cjrkjmnn:0c250Dpa3vuyQ_d7LrK6YybyiJ8Pcsl8@mel.db.elephantsql.com/cjrkjmnn')
                # create a cursor
                cur = conn.cursor()

                # execute a statement
                print('PostgreSQL database version:')
                cur.execute('SELECT version()')

                # display the PostgreSQL database server version
                db_version = cur.fetchone()
                print(db_version)

                # close the communication with the PostgreSQL
                cur.close()

                Postgre.conn = conn
            except (Exception, psycopg2.DatabaseError) as error:
                print(error)

        return Postgre.conn

    @staticmethod
    def close_connection():
        if Postgre.conn is not None:
            Postgre.conn.close()
            print('Database connection closed.')


if __name__ == '__main__':

    convar = Postgre.connect()
    curr = convar.cursor()

    # We get an input of ID from the user/front-end
    stu_ID = 10012

    sql = """
      Select *from complaint_users c
      inner join student s
      on c.user_ID = s.stu_ID
      where c.user_ID = stu_ID;
    """

    # curr.execute(
    #     """SELECT * FROM customer;"""
    # )
    curr.execute(sql)
    curr.execute("select * from student;")
    res = curr.fetchall()
    print(res)
    curr.close()
    convar.close()