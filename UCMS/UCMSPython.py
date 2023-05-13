import psycopg2

class Postgre:
    conn = None

    @staticmethod
    def connect():
        """ Connect to the PostgreSQL database server """
        if Postgre.conn is None:
            conn = None
            try:
                # read connection parameters
                # params = config()
                params = {'host': 'localhost',
                          'database': 'UCMS02',
                          'user': 'romaisa',
                          'password': 'romaisa',
                          'port': 5432
                          }

                # connect to the PostgreSQL server
                print('Connecting to the PostgreSQL database...')
                conn = psycopg2.connect(**params)
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

