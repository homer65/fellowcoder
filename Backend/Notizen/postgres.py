import psycopg2

class Postgres():
    
    def __init__(self):
        self.connection = None
        
    def connect(self):
        user = ""
        password = ""
        with open("postgres.login","r") as f:
            for satz in f:
                worte = satz.split("=")
                if len(worte) > 1:
                    user = worte[0]
                    password = worte[1]
        try:
            self.connection = psycopg2.connect(user = user,
                                               password = password,
                                               host = "45.129.182.115",
                                               port = "5432",
                                               database = "fellowcoder")
        except (Exception, psycopg2.Error) as error:
            print("Error Postgres bei connect ",error)
            
    def selectPasswort(self,benutzer):
        erg = ""
        try:
            if self.connection == None: self.connect()
            sql = "select passwort from login"
            sql += " where benutzer = %s"
            cursor = self.connection.cursor()
            cursor.execute(sql,[benutzer])
            records = cursor.fetchall()
            for row in records:
                erg = row[0]   
            cursor.close()
        except (Exception, psycopg2.Error) as error :
            print ("Error PostgreSQL bei selectPasswort ", error)
        return erg 
    
    def setPasswort(self,benutzer,passwort_hash):
        erg = ""
        try:
            if self.connection == None: self.connect()
            sql = "update login"
            sql += " set passwort = %s where benutzer = %s"
            cursor = self.connection.cursor()
            cursor.execute(sql,(passwort_hash,benutzer))
            cursor.close()
            self.connection.commit()
        except (Exception, psycopg2.Error) as error :
            print ("Error PostgreSQL bei setPasswort ", error)
        return erg 