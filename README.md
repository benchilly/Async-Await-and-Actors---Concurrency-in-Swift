# Async-Await-and-Actors---Concurrency-in-Swift
Learn async/await, actors, async-let, task groups, unstructured concurrency, detached tasks and more!

## 📖 Lectures
<!-- 1.Understanding Concurrent Programming in iOS -->
<article class="lecture1">
  <details>
    <!-- Title -->
    <summary><strong>1️⃣ Understanding Concurrent Programming in iOS</strong></summary>
    <!-- Contents -->
    <section>
      <ul>
        <!-- What is Concurrency? -->
        <li>
          <h3>What is Concurrency?</h3>
          <p><strong>Concurrency (동시성): 여러 가지 일을 동시에 하려고 하는 것</strong></p>
          <aside class="impl">
            <blockquote>
              <p>💻 Concurrency 구현</p>
              <ul>
                <li>시분할 (Time-slicing)을 통해 구현</li>
                <li>Host OS의 Multi CPU core 사용이 가능한 경우, 병렬처리 방식으로 구현</li>
              </ul>
            </blockquote>
          </aside>
          <figure>
            <img src="https://github.com/user-attachments/assets/82c69574-68e6-4788-a77f-1f693c8e205b" />
            <figcaption>
              <p>Main-Thread는 <strong>'한 번에 하나씩 작업을 처리'</strong>하는 <strong>"Serial Queue"</strong>이므로, <br>
                Downloading Images와 같이 무거운 작업이 진행될 때, 해당 스레드를 점유하고 있어 다른 UI Event 진행이 불가능</p>
            </figcaption>
          </figure>
          <figure>
            <img src="https://github.com/user-attachments/assets/f8a5e82a-8a7c-4f0d-895d-a4805402bcbe" />
            <figcaption>
              <p>Image나 기타 자료를 다운로드하는 무거운 작업들은 Background-Thread에서 수행!</p>
            </figcaption>
          </figure>
          <br>
          <aside class="tip">
            <blockquote>
              <p><strong>⭐ Main Queue는 UI Event나 매우 빠르게 발생할 수 있는 event를 위해 사용!</strong></p>
              <p>&emsp; 사용자 인터페이스는 매끄럽고 부드럽게 작동해야 하며, 어떠한 작업을 수행하더라도 끊김이 있어서는 안됨</p>
            </blockquote>
          </aside>
          <br>
        </li>
        <!-- Grand Central Dispatch -->
        <li>
          <h3>Grand Central Dispatch</h3>
          <p><strong>GCD: Multi-core 및 기타 대칭형 multiprocessing system을 사용하는 system에 대한 App 지원을 최적화하기 위한 기술</strong></p>
          <aside class="tip">
            <blockquote>
              <p><strong>🟰 즉, GCD는 OS 레벨의 동시성/멀티스레딩을 위한 라이브러리로, Dispatch Framework를 통해 사용 가능</strong></p>
            </blockquote>
          </aside>
          <ul>
            <li>
              <h4>Dispatch Queue의 특성</h4>
              <figure>
                <img src="https://github.com/user-attachments/assets/1f0dd4a6-e3f4-4924-a08e-3b789dcf76ca" />
                <figcaption>
                  <ol type="1">
                    <li><strong>Serial: 하나의 Thread에서 '순차 실행'</strong>하며, 작업의 순서가 중요한 경우 직렬처리를 사용</li>
                    <li><strong>Concurrent: 여러 Thread에서 '동시 실행'</strong>하며, 작업의 중요도 및 성격 등을 고려했을 때, 유사한 여러개의 작업 처리 시 사용</li>
                  </ol>
                </figcaption>
              </figure>
            </li>
            <li>
              <h4>Dispatch Queue의 종류</h4>
              <figure>
                <img src="https://github.com/user-attachments/assets/3c2d1d56-abb0-4017-b49d-f8b02319b2ea" />
                <figcaption>
                  <ol type="1">
                    <li><strong>Main Queue</strong>: GCD가 제공하는 시스템 큐로, <strong>UI 작업 처리에 사용되는 직렬 큐</strong> (e.g. <code>DispatchQueue.main</code>)</li>
                    <li><strong>Global Queue</strong>: GCD가 제공하는 글로벌 동시 큐로, <strong>여러 작업을 동시에 실행할 수 있는 큐</strong> (e.g. <code>DispatchQueue.global(qos:)</code>)</li>
                    <li>Custom Queue: 사용자 정의 직렬/동시 큐 (e.g. <code>DispatchQueue(label:, attributes:)</code>)</li>
                  </ol>
                </figcaption>
              </figure>
              <br>
            </li>
          </ul>
        </li>
      </ul>
    </section>
  </details>
</article>

<!-- 2.Getting Started with Async and Await -->
<article class="lecture2">
  <details>
    <!-- Title -->
    <summary><strong>2️⃣ Getting Started with Async and Await</strong></summary>
    <!-- Contents -->
    <section>
      <ul>
        <!-- Sync & Async -->
        <li>
          <h3>Sync & Async</h3>
          <ul>
            <li>
              <p><strong>Synchronous (동기): 작업을 시키고 작업의 완료를 기다림</strong></p>
              <figure>
                <img src="https://github.com/user-attachments/assets/cafc677a-cae6-4e54-b052-fae1e30c3996" />
                <figcaption>
                  <p>작업이 끝날 때까지 <strong>해당 thread가 점유되어 다른 작업 수행이 불가능!</strong></p>
                  <aside class="tip">
                    <blockquote>
                      <p><strong>Thread가 점유되어 다른 일의 수행이 불가능한 상태를 'Thread-Blocking'이라고 한다</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
            </li>
            <li>
              <p><strong>Asynchronous (비동기): 작업을 시키고 작업의 완료를 기다리지 않음</strong></p>
              <figure>
                <img src="https://github.com/user-attachments/assets/c8ed4c40-183b-40f3-8e04-67bda676fb95" />
                <figcaption>
                  <p><strong>해당 thread가 점유되지 않아 다른 작업 수행이 가능!</strong></p>
                  <aside class="tip">
                    <blockquote>
                      <p><strong>이를 'Non Thread-Blocking'이라고 한다</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
              <br>
            </li>
          </ul>
        </li>
        <!-- Async & Await -->
        <li>
          <h3>Async & Await</h3>
          <p><strong>async & await: 기존의 비동기 처리 코드를 "동기 처리처럼" 보일 수 있도록 지원</strong></p>
          <aside class="tip">
            <blockquote>
              <p>🟣 <code>async</code> & <code>await</code> 의미</p>
              <ul>
                <li><code>async</code>: <strong>함수가 비동기적임을 나타냄</strong></li>
                <li><code>await</code>: <strong>비동기 함수 및 비동기 Context 내에서 다른 비동기 함수를 호출할 때 사용</strong><br></li>
              </ul>
              <br>
              <p>&emsp;&emsp; 비동기 context에는 <code>.task()</code>, <code>Task {}</code>, <code>async</code>함수 등이 존재</p>
            </blockquote>
          </aside>
          <ul>
            <li>
              <h4>Async/await 등장 배경</h4>
              <p>기존의 <code>@escaping</code> closures를 이용한 비동기 처리 코드는 Deeply-nested closures (중첩 클로저)가 됨으로써, <br>
                코드가 verbose (장황), complex (복잡), incorrect (부정확) 해졌고, 오류처리에 어려움이 있었음</p>
              <aside class="tip">
                <blockquote>
                  <p>⭐ <code>async</code>/<code>await</code>가 등장함에 따라, <strong>Straight-line code 작성 가능 + 가독성이 크게 향상 📈</strong></p>
                </blockquote>
              </aside>
            </li>
            <li>
              <h4>Async/await 내부 원리 (Thread Control)</h4>
              <figure>
                <img src="https://github.com/user-attachments/assets/e5f084b3-919a-4545-8d5b-15bc1cb333ab" />
                <figcaption>
                  <ol type="1">
                    <li>호출: caller가 callee (async)를 호출하면, caller가 실행되던 Thread Control을 callee에게 전달</li>
                    <li>진행: callee는 스레드 제어권을 포기하는 <strong>'suspend가 가능'</strong> (callee가 일시중단이 되면, caller도 일시중단됨)
                      <p></p>
                      <aside class="tip">
                        <blockquote>
                          <p><strong>⭐ <code>await</code></strong>는 async 함수가 <strong>"일시 중단될 수도 있음"</strong>을 나타내며, 
                            이는 <strong>Non Thread-Blocking</strong>이다</p>
                          <p>&emsp; 반드시 suspend 된다는 것이 아님!
                            (<code>await</code>를 <strong>'potential suspension point (잠재적인 일시중단 지점)'</strong>이라고 표현함)</p>
                        </blockquote>
                      </aside>
                    </li>
                    <li>suspend: 스레드 제어권은 <strong>System에게 전달되고</strong>, System은 thread를 사용해 <strong>다른 작업을 수행 (우선순위가 높은 작업부터 처리)</strong>
                      <p></p>
                      <aside class="tip">
                        <blockquote>
                          <p><strong>⭐ 함수가 일시중단된 동안 App의 상태가 크게 바뀔 수 있다</strong></p>
                        </blockquote>
                      </aside>
                    </li>
                    <li>resume: suspend된 비동기 함수를 재개 (resume)하는 단계</li>
                    <li>종료: callee가 종료되면, 스레드 제어권을 caller에게 반납
                      <p></p>
                      <aside class="tip">
                        <blockquote>
                          <p>⭐ 스레드 제어권을 System으로부터 다시 전달받을 때, 할당된 thread는 이전과는 <strong>'다른 thread가 될 수도 있음'</strong></p>
                        </blockquote>
                      </aside>
                    </li>
                  </ol>
                </figcaption>
              </figure>
            </li>
          </ul>
          <br>
        </li>
      </ul>
    </section>
  </details>
</article>

<!-- 3.Understanding MVVM Design Pattern -->
<article class="lecture3">
  <details>
    <!-- Title -->
    <summary><strong>3️⃣ Understanding MVVM Design Pattern</strong></summary>
    <!-- Contents -->
    <section>
      <ul>
        <!-- What are Design Patterns? -->
        <li>
          <h3>What are Design Patterns?</h3>
          <p><strong>Design Pattern: 특정 시나리오에서 특정 문제를 해결하기 위한 최적의 방법</strong></p>
          <ul>
            <li>Best practice: 문제 해결을 위한 최적의 방법</li>
            <li>Relationships between classes & objects: class와 object 간의 관계</li>
            <li>Speed Up development: 개발 속도 향상</li>
          </ul>
          <p></p>
          <aside class="tip">
            <blockquote>
              <p>Design Pattern은 언어, Framework에 구애받지 않음</p>
            </blockquote>
          </aside>
          <br>
        </li>
        <!-- What is MVVM & Why MVVM (with. MVC, MVP) -->
        <li>
          <h3>What is MVVM & Why MVVM (with. MVC, MVP)</h3>
          <figure>
            <table>
              <tr>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/861f05ae-2972-4eb9-9e31-4086e8319a40" />
                  <p>MVC</p>
                </td>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/388c39ec-8e55-420a-b7fb-0743e1793d69" />
                  <p>MVP</p>
                </td>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/6d7dadfd-e1e8-4e49-bb41-d8f78344f8d4" />
                  <p>MVVM</p>
                </td>
              </tr>
            </table>
          </figure>
          <ol type="1">
            <!-- MVC (Model-View-Controller) -->
            <li>
              <h3>MVC (Model-View-Controller)</h3>
              <ul type="circle">
                <!-- Traditional MVC (Smalltalk) -->
                <li>
                  <h4>Traditional MVC (Smalltalk)</h4>
                  <figure>
                    <img src="https://github.com/user-attachments/assets/afb69710-b87d-45ee-9d49-9ba86833280f" />
                    <figcaption>
                      <aside class="tip">
                        <blockquote>
                          <p><strong>서로 밀접하게 연결되어 있어, 독립적 수준에서의 Unit Test ❌</strong></p>
                        </blockquote>
                      </aside>
                      <ul type="circle">
                        <li>Model: View에게 자신의 상태 변경 사항을 알림</li>
                        <li>View: 중첩된 View들의 복합체 (즉, View Hierarchy를 의미)</li>
                        <li>Controller: 하나 이상의 View에 대한 전략 구현</li>
                      </ul>
                      <p></p>
                      <aside class="tip">
                        <blockquote>
                          <p>🔥 Traditional MVC의 문제점 (Theoritical Problem)</p>
                          <ul type="circle">
                            <li>
                              <p><strong>View와 Model은</strong> Notification으로 연결된 <strong>상호 의존 관계</strong> (= <strong>객체의 재사용성 저해</strong>)</p>
                            </li>
                          </ul>
                        </blockquote>
                      </aside>
                    </figcaption>
                  </figure>
                </li>
                <!-- Cocoa MVC -->
                <li>
                  <h4>Cocoa MVC</h4>
                  <figure>
                    <table>
                      <tr>
                        <td align="center">
                          <img src="https://github.com/user-attachments/assets/5e7d6033-b7a5-4ed1-bc21-0565d50a7e41" />
                          <p>Cocoa MVC (Expectation)</p>
                        </td>
                        <td align="center">
                          <img src="https://github.com/user-attachments/assets/3a90a7ff-4d75-4d2c-9629-b851cd6abc61" />
                          <p>Cocoa MVC (Reality)</p>
                        </td>
                      </tr>
                    </table>
                    <figcaption>
                      <aside class="tip">
                        <blockquote>
                          <p><strong>⭐ View와 Model은 "Reusable한 객체"여야함</strong></p>
                        </blockquote>
                      </aside>
                      <ul type="circle">
                        <li>Model: Data와 기능(Function)을 하나의 단위로 묶어 Encapsulation</li>
                        <li>View: App의 "외관과 느낌 (Look and Feel)"</li>
                        <li>
                          Controller: View와 Model 사이의 <strong>"양방향 중재자"</strong>
                          <p></p>
                          <aside class="tip">
                            <blockquote>
                              <p><strong>💡 그러나, Controller는 View Lifecycle과 강하게 연결되어 있어 분리가 힘듦 (-> "Massive"한 특성을 지니게 됨)</strong></p>
                              <ul type="circle">
                                <li>Model에게 맞지 않는 모든 비즈니스 로직 (e.g. Event 처리, View Layout 설정 등)</li>
                                <li>View의 Life Cycle과 밀접하게 연관 (e.g. viewDidLoad() 등)</li>
                                <li>Delegate 및 DataSource의 역할</li>
                                <li>(필요에 따른) 기타 네트워킹 작업 등</li>
                              </ul>
                            </blockquote>
                          </aside>
                        </li>
                      </ul>
                      <p></p>
                      <aside class="tip">
                        <blockquote>
                          <p>🔥 Traditional MVC 구현의 실질적 문제점 (Practical Problem)</p>
                          <ul type="circle">
                            <li>
                              <p>Mediating Controller는 NSController의 subclass로 Binding 기술을 지원, <br>
                              이를 사용하지 않으면 View와 Model의 Notification에 대해 반응하는 코드를 custom으로 작성해야함</p>
                            </li>
                          </ul>
                        </blockquote>
                      </aside>
                    </figcaption>
                  </figure>
                </li>
                <li>
                  <h4>(Cocoa) MVC의 특징</h4>
                  <ol type="1">
                    <li>Distribution: View와 Model은 분리가 잘 되지만, View와 Controller는 의존관계로 강하게 결합됨</li>
                    <li>Testability: Model에 대해서만 Testable 함</li>
                    <li>Ease of use: 다른 패턴에 비해 가장 적은 양의 코드로 빠른 개발 가능</li>
                  </ol>
                </li>
              </ul>
              <br>
            </li>
            <!-- MVP (Model-View-Presenter) -->
            <li>
              <h3>MVP (Model-View-Presenter)</h3>
              <figure>
                <img src="https://github.com/user-attachments/assets/3ff3367a-5af7-437e-96ca-c7a340c0e9bd" />
                <figcaption>
                  <aside class="tip">
                    <blockquote>
                      <p><strong>⭐ View는 Dumb, View의 Event는 Presenter가 담당</strong></p>
                    </blockquote>
                  </aside>
                  <ul type="circle">
                    <li>Model: 서비스에 사용되어지는 원천(source) 데이터</li>
                    <li>View: <strong>Controller와 View (UIButton, UILabel 등)를 "하나의 View로 취급"</strong></li>
                    <li>Presenter: View와 Model의 중재자로, <strong>"화면에 보여줄 것들을 관리"하는 요소</strong></li>
                  </ul>
                  <p></p>
                  <aside class="tip">
                    <blockquote>
                      <p>⭐ View와 Presenter는 <strong>Protocol (Interface)을 통해 서로의 존재를 앎</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
              <ul type="circle">
                <li>
                  <h4>Presenter의 특징</h4>
                  <ul type="circle">
                    <li>View의 <strong>Lifecycle에 관여 ❌</strong></li>
                    <li>View <strong>Layout과 관련된 코드 ❌</strong></li>
                    <li>단지 View의 <strong>state와 data를 업데이트 🔄</strong></li>
                  </ul>
                </li>
                <li>
                  <h4>Presenter의 장•단점</h4>
                  <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                      <tr>
                        <th>Pros.</th>
                        <th>Cons.</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>대부분의 B.L들을 테스트 할 수 있게됨</td>
                        <td>View와 1:1로 대응되어 View 생성 시, Presenter도 같이 생성되어야 함</td>
                      </tr>
                    </tbody>
                  </table>
                </li>
                <li>
                  <h4>MVP의 특징</h4>
                  <ol type="1">
                    <li>Distribution: 대부분의 책임이 Presenter와 Model로 나뉘어지고, View와 Model은 Dumb</li>
                    <li>Testability: 대부분의 비즈니스 로직들을 테스트 할 수 있음</li>
                    <li>Ease of use: MVC에 비해 많은 양의 코드를 요구하지만, 각 요소에 대해서는 역할을 분명히 할 수 있음</li>
                  </ol>
                </li>
              </ul>
              <br>
            </li>
            <!-- MVVM (Model-View-ViewModel) -->
            <li>
              <h3>MVVM (Model-View-ViewModel)</h3>
              <figure>
                <img src="https://github.com/user-attachments/assets/ff992e68-4306-4a32-b790-e2e97e3b54a6" />
                <figcaption>
                  <aside class="tip">
                    <blockquote>
                      <p><strong>⭐ View는 ViewModel을 "관찰"하고, ViewModel은 Data, State 요소만 갖음</strong></p>
                    </blockquote>
                  </aside>
                  <ul type="circle">
                    <li>Model: 서비스에 사용되어지는 원천(source) 데이터</li>
                    <li>View: Controller와 View (UIButton, UILabel 등)를 하나의 View로 취급</li>
                    <li>ViewModel: View와 Model의 중재자</li>
                  </ul>
                  <p></p>
                  <aside class="tip">
                    <blockquote>
                      <p>⭐ View는 ViewModel과 <strong>Binding을 통해 UI를 update함으로써, View와 ViewModel은 N:1 관계가 성립</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
              <ul type="circle">
                <li>
                  <h4>ViewModel의 특징</h4>
                  <ul type="circle">
                    <li>ViewModel은 <strong>View를 직접 update ❌</strong></li>
                    <li><strong>View가 필요한 State, Data를 갖고, 이를 방출 (Reactive Programming)</strong></li>
                  </ul>
                  <p></p>
                  <aside class="tip">
                    <blockquote>
                      <p>💡 View와 ViewModel의 Binding 방법</p>
                      <p>&emsp; KVO (Key-Value Observing), NotificationCenter, Property Observers 등을 사용 <br>
                        &emsp; 그러나, 이를 바인딩이라고 표현하기에는 애매하고 사용이 불편 (이후 <strong>RxSwift, Combine Framework</strong>가 등장)</p>
                    </blockquote>
                  </aside>
                </li>
                <li>
                  <h4>MVP와 MVVM의 차이</h4>
                  <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                      <tr>
                        <th>MVP</th>
                        <th>MVVM</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>UI 이벤트를 Presenter에게 넘기고 View는 자신의 UI를 직접 갱신 ❌</td>
                        <td>View는 바인딩을 통해 ViewModel의 상태에 따라 UI를 갱신 ✅</td>
                      </tr>
                    </tbody>
                  </table>
                </li>
                <li>
                  <h4>MVVM의 특징</h4>
                  <ol type="1">
                    <li>Distribution: MVP의 View보다 MVVM의 View가 가지는 책임이 더 큼</li>
                    <li>Testability: View와 ViewModel은 서로 의존관계가 아니므로 테스트하기 쉬움</li>
                    <li>Ease of use: MVP와 비슷한 양의 코드를 요구하지만, View의 이벤트를 Presenter를 통해 알리고 수동으로 View를 갱신하는 MVP와 달리 바인딩을 사용하면 MVVM이 훨씬 더 간편함</li>
                  </ol>
                </li>
              </ul>
            </li>
          </ol>
          <br>
        </li>
      </ul>
    </section>
  </details>
</article>

<!-- 4.Exposing your Function As Async/Await Using Continuation -->
<article class="lecture4">
  <details>
    <!-- Title -->
    <summary><strong>4️⃣ Exposing your Function As Async/Await Using Continuation</strong></summary>
    <!-- Contents -->
    <section>
      <ul>
        <!-- What is Continuation? -->
        <li>
          <h3>What is Continuation?</h3>
          <p><strong>Continuation: 비동기 코드와 동기 코드 사이를 연결해주는 Bridge</strong></p>
          <aside class="tip">
            <blockquote>
              <p><strong>🟰 즉, 기존의 callback 함수를 <code>async</code>/<code>await</code> 스타일로 변환</strong></p>
            </blockquote>
          </aside>
          <ul>
            <li>
              <h4>Continuation의 장•단점</h4>
              <table border="1" cellpadding="10" cellspacing="0">
                <thead>
                  <tr>
                    <th>Pros.</th>
                    <th>Cons.</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <ul type="circle">
                        <li>callback API를 Async/Await로 전환
                          <ul>
                            <li><strong>Legacy callback API 유지</strong> + <strong>점진적 Migration 가능</strong></li>
                          </ul>
                        </li>
                        <li>Straight-line code
                          <ul>
                            <li><strong>가독성 & 유지보수성 개선</strong></li>
                          </ul>
                        </li>
                        <li>withCheckedContinuation의 안정성
                          <ul>
                            <li>Runtime 시, <strong>resume을 한 번만 호출했는지 Check</strong></li>
                          </ul>
                        </li>
                      </ul>
                    </td>
                    <td>
                      <ul type="circle">
                        <li>resume 누락시, Task 무한 대기
                          <ul>
                            <li>영원히 suspend 상태가 됨 (<strong>= DeadLock 발생 가능성</strong>)</li>
                          </ul>
                        </li>
                        <li>Straight-line code
                          <ul>
                            <li><strong>가독성 & 유지보수성 개선</strong></li>
                          </ul>
                        </li>
                        <li>withCheckedContinuation의 안정성
                          <ul>
                            <li>Runtime 시, <strong>resume을 "한 번만" 호출했는지 Check</strong></li>
                          </ul>
                        </li>
                      </ul>
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
          <br>
        </li>
        <!-- Continuation 종류 -->
        <li>
          <h3>Continuation 종류</h3>
          <ul>
            <li><strong>withCheckedContinuation</strong>: Runtime 시, <strong>"안정성을 보장"하는 방법</strong></li>
            <li><strong>withUnsafeContinuation</strong>: 더 낮은 수준의 연산을 원할 때 사용, <strong>Runtime "안정성 검증이 없음"</strong></li>
          </ul>
          <br>
        </li>
        <!-- Example -->
        <li>
          <h3>Example.</h3>
          <figure>
            <table>
              <tr>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/d52d3501-7a18-4ac3-b9ce-927ce3b867cc" />
                  <p>Callback API</p>
                </td>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/589b4754-6b75-4796-85df-04314872077e" />
                  <p>Async/Await (Using Continuation)</p>
                </td>
              </tr>
            </table>
            <figcaption>
              <aside class="tip">
                <blockquote>
                  <p><strong>⭐ Wrapping을 통한 Proxy Pattern 적용으로 기존의 callback API는 유지하면서, Async/Await 함수로 Migration</strong></p>
                  <p>&emsp; 비동기 Task 재개 시, 호출할 수 있는 Methods</p>
                  <ul type="circle">
                    <li>resume(returning:)</li>
                    <li>resume(throwing:)</li>
                    <li>resume(with:)</li>
                    <li>resume()</li>
                  </ul>
                </blockquote>
              </aside>
            </figcaption>
          </figure>
        </li>
        <br>
      </ul>
    </section>
  </details>
</article>

<!-- 5.Understanding Structured Concurrency in Swift -->
<article class="lecture5">
  <details>
    <!-- Title -->
    <summary><strong>5️⃣ Understanding Structured Concurrency in Swift</strong></summary>
    <!-- Contents -->
    <section>
      <ul>
        <li>
          <h3>Prerequisites.</h3>
          <figure>
            <table>
              <tr>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/d219d976-5bef-4f44-805a-01fbe0e0f473" />
                  <p>Sync / Async</p>
                </td>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/e31ff028-0700-4771-86ff-1253524a2d17" />
                  <p>Serial / Concurrent</p>
                </td>
                <td align="center">
                  <img src="https://github.com/user-attachments/assets/6710e805-42fb-41ba-84f1-78c8873caf1c" />
                  <p><code>async</code> / <code>await</code></p>
                </td>
              </tr>
            </table>
          </figure>
          <br>
        </li>
        <!-- Async-let Tasks -->
        <li>
          <h3>Async-let Tasks (= Async-let Binding / Concurrent Binding)</h3>
          <p><strong><code>async let</code>: 여러 비동기 작업을 "동시에" 실행</strong></p>
          <aside class="tip">
            <blockquote>
              <p>💡 "동시"의 의미</p>
              <ul type="circle">
                <li><strong>논리적 관점: Concurrent (동시성)</strong></li>
                <li><strong>물리적 관점: Parallel (병렬성)</strong></li>
              </ul>
            </blockquote>
          </aside>
          <aside class="tip">
            <blockquote>
              <p>⭐ 동시성 vs 병렬성</p>
              <ul type="circle">
                <li>Concurrent: <strong>Context-Switching을 통해</strong> 여러 작업이 <strong>"동시에 실행되는 것처럼"</strong> 보이게 하는 것</li>
                <li>Parallel: <strong>Multi-core를 통해</strong> <strong>"실제로 동시에 독립적으로 실행"</strong>되는 것</li>
              </ul>
            </blockquote>
          </aside>
          <br>
          <ul>
            <li>
              <h4><code>async-let</code> 사용이유</h4>
              <p>
                여러 비동기 작업을 단순히 <code>await</code>로만 사용하게 될 경우, suspend를 통해 sequential하게 동작함으로써 총 작업의 소요 시간이 길어짐 <br>
                <code>async-let</code>은 여러 비동기 작업을 concurrent하게 실행시킴으로써, 병렬성을 확보할 수 있음
              </p>
            </li>
            <li>
              <h4>기존 Async와 Async-let의 동작 원리</h4>
              <figure>
                <table>
                  <tr>
                    <td align="center">
                      <img src="https://github.com/user-attachments/assets/fdadebef-f387-4497-b2be-88e1d4db652f" />
                      <p>기존 Async의 동작 원리</p>
                    </td>
                    <td align="center">
                      <img src="https://github.com/user-attachments/assets/b1a412f3-37d0-4bf9-a1b7-ca044dad82bd" />
                      <p>Async-let의 동작 원리</p>
                    </td>
                  </tr>
                </table>
                <figcaption>
                  <aside class="tip">
                    <blockquote>
                      <p>⭐ Sequential Bindings와 Concurrent Bindings의 가장 큰 차이는 <strong>실행의 흐름 갯수 차이!</strong></p>
                      <p>&emsp;<code>async let</code>은 <strong>Child Task라는 새로운 하위 작업을 생성함</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
              <br>
            </li>
          </ul>
          <br>
        </li>
        <!-- Task tree -->
        <li>
          <h3>Task tree</h3>
          <p><strong>Task tree: Parent Task와 Child Task 관계 기반의 Hierarchy</strong></p>
          <aside class="tip">
            <blockquote>
              <p><strong>⭐ Task tree는 Structured Concurrency (구조적 동시성)의 핵심!</strong></p>
            </blockquote>
          </aside>
          <br>
          <ul>
            <li>
              <h4>Task tree 특징</h4>
              <ul type="circle">
                <li>
                  <p>우선순위 상속: Task의 속성 (e.g. cancellation, priority, task-level variables, etc.)으로부터 영향을 받음</p>
                  <aside class="tip">
                    <blockquote>
                      <p>즉, <strong>Child Task는 Parent Task로부터 속성들을 상속받음</strong></p>
                    </blockquote>
                  </aside>
                </li>
                <li>
                  <p>생명주기 자동관리: <strong>Child Task가 모두 finish 되어야 Parent Task도 finish됨</strong></p>
                  <aside class="tip">
                    <blockquote>
                      <ul type="circle">
                        <li><strong>Parent와 Child는 Link 관계로 이루어져 있으며, 이는 Parent는 Child가 모두 끝난 후에야 작업을 마칠 수 있다는 rule을 강제함</strong></li>
                        <li>만약 <strong>Child가 error를 냈다면 Parent는 암묵적 취소 상태</strong>, <strong>Child가 끝나지 않았다면 Parent는 대기 상태</strong>가 됨</li>
                      </ul>
                    </blockquote>
                  </aside>
                </li>
                <li>
                  <p>취소 전파: <strong>Parent가 취소되면, Child에 취소가 자동으로 전파됨</strong></p>
                </li>
              </ul>
            </li>
            <li>
              <h4>Task tree 동작 원리</h4>
              <figure>
                <table>
                  <tr>
                    <td align="center">
                      <img src="https://github.com/user-attachments/assets/d898e26b-cfe9-44cf-98e9-89ee07a35d38" />
                    </td>
                    <td align="center">
                      <img src="https://github.com/user-attachments/assets/13379661-ae25-4bfb-b57d-6c5b3a82e047" />
                    </td>
                    <td align="center">
                      <img src="https://github.com/user-attachments/assets/3dc8f77d-127b-4a59-816a-a398ce58fdb2" />
                    </td>
                  </tr>
                </table>
                <figcaption>
                  <p>
                    <code>metadata</code> Task를 await하는 과정에서 error가 발생되었다면, fetchOneThumbnail()은 그 error를 던지며 종료됨
                    <br><br>
                    그러나, fetchOne()이 종료되면 두 번째 Task는?
                    <br><br>
                    👉 두번째 Child Task인 <code>try await UIImage(data: data)</code>는 <strong>Swift가 "자동으로 cancel을 표시"</strong>하고, 
                    <br>
                    &emsp; fetchOneThumbnail()을 종료하기 전에 해당 unawaited Task가 완료될 때까지 기다림
                  </p>
                  <aside class="tip">
                    <blockquote>
                      <p>Cancelled는 <strong>"결괏값이 필요 없어졌음"을 의미</strong>하는 것으로 <strong>Task를 중지하는 것은 아님</strong></p>
                    </blockquote>
                  </aside>
                  <br>
                  <ul type="circle">
                    <li>비정상적인 종료가 발생하면, unawaited task들을 자동으로 취소(Canceled) 상태로 표시</li>
                    <li>상위 task가 cancel되면 하위 task도 자동으로 cancel</li>
                    <li>상위 task가 finish 되려면, 반드시 하위 task가 finish 되어야함</li>
                  </ul>
                  <br>
                  <aside class="tip">
                    <blockquote>
                      <p>⭐ 이러한 <strong>"보장 (Guarantees)"은 구조적 동시성 (Structured Concurrency)의 근간!</strong></p>
                    </blockquote>
                  </aside>
                </figcaption>
              </figure>
              <br>
            </li>
          </ul>
        </li>
      </ul>
    </section>
  </details>
</article>
