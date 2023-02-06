from sqlalchemy import create_engine, MetaData

engine = create_engine('mysql+pymysql://root:@#$password81@localhost:3306/appDatabase')
mate_data = MetaData()
conn = engine.connect()