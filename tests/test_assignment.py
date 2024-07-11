import os
import pathlib
import pytest

def test_q1_file():
    assert pathlib.Path('q1.txt').is_file(), 'Must create q1.txt'

def test_q1_valid():
    with open('q1.txt') as f:
        jwt = f.read().strip()
        test_url = 'https://learn.operatoroverload.com/~jmadar/lab7/q1.sh';
        result = os.popen(f'curl -s --head -H "Authorization: Bearer {jwt}" {test_url}').read()
        assert '200' in result

def test_q2_file():
    assert pathlib.Path('q2.sh').is_file(), 'Must create q2.sh'
    
@pytest.fixture
def q2_content():
    with open('q2.sh') as f:
        return f.read()

def test_q2_content_1(q2_content):
    assert 'openssl' in q2_content, "Must call openssl to create hmac signature"
    assert 'hmac' in q2_content, "Must call openssl to create hmac signature"

def test_q2_content_2(q2_content):
    assert 'curl' in q2_content, "Must use curl"
    assert 'https://learn.operatoroverload.com/~jmadar/lab7/q2.sh' in q2_content, "Must access q2.sh on my server"
    

def test_q2_execute():
    result = os.popen('./q2.sh').read()
    assert 'cowboy' in result
