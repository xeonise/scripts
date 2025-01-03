from flask import Flask, request
app = Flask(__name__)

current_job_id = None
current_place_id = None

@app.route('/getserver', methods=['GET', 'POST'])
def get_server():
    global current_job_id, current_place_id

    if request.method == 'POST':
        job_id = request.headers.get('JobId')
        place_id = request.headers.get('PlaceId')
        if job_id and place_id:
            current_job_id = job_id
            current_place_id = place_id
            return "JobId and PlaceId updated", 200
        else:
            return "Error: Missing JobId or PlaceId", 400

    elif request.method == 'GET':
        if current_job_id and current_place_id:
            return f"JobId: {current_job_id}, PlaceId: {current_place_id}", 200
        else:
            return "Error: JobId and PlaceId not set", 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
