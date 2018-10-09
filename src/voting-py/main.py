from flask import Flask, jsonify, request

app = Flask(__name__)

votes = {}


@app.route('/vote', methods=['GET', 'POST', 'PUT', 'DELETE'])
def voting_router():
    if request.method == 'GET':
        return get_votes()
    elif request.method == 'POST':
        return start_voting(request.get_json())
    elif request.method == 'PUT':
        return vote(request.get_json())
    elif request.method == 'DELETE':
        return finish_voting()
    return "", 403


def get_votes():
    return jsonify(votes), 200


def start_voting(data):
    votes.update({topic: 0 for topic in data['topics']})
    return jsonify(votes), 200


def vote(data):
    option = data['topic']
    votes[option] = votes[option] + 1
    return jsonify(votes), 200


def finish_voting():
    winner = max(votes, key=votes.get)
    return winner, 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=8081)
